use t::APISIX 'no_plan';

repeat_each(1);
no_long_string();
no_root_location();

add_block_preprocessor(sub {
    my ($block) = @_;

    # setup default conf.yaml
    my $extra_yaml_config = $block->extra_yaml_config // <<_EOC_;
plugins:
    - demo
_EOC_

    $block->set_value("extra_yaml_config", $extra_yaml_config);

    if (!$block->request) {
        $block->set_value("request", "GET /t");
    }

    if ((!defined $block->error_log) && (!defined $block->no_error_log)) {
        $block->set_value("no_error_log", "[error]");
    }
});

run_tests;

__DATA__

=== TEST 1: hello, world
This is just a simple demonstration of the
echo directive provided by ngx_http_echo_module.
--- config
    location = /t {
        content_by_lua_block {
            ngx.say('hello, world!')
        }
    }
--- response_body
hello, world!



=== TEST 2: enable custom plugin using admin api
--- config
    location = /t {
        content_by_lua_block {
            local t = require("lib.test_admin").test
            local code, body = t('/apisix/admin/routes/1',
                ngx.HTTP_PUT,
                [[{
                    "plugins": {
                        "demo": {
                            "body": "test"
                        }
                    },
                    "upstream": {
                        "nodes": {
                            "127.0.0.1:1980": 1
                        },
                        "type": "roundrobin"
                    },
                    "uri": "/demo"
                }]]
                )

            if code >= 300 then
                ngx.status = code
            end
            ngx.say(body)
        }
    }
--- response_body
passed



=== TEST 3: verify demo access logic
--- request
GET /demo
--- response_body
{"message":"test"}



=== TEST 4: test public api
--- request
GET /apisix/plugin/demo/public_api
--- response_body
{"msg":"public_api"}



=== TEST 5: test control api
--- pipelined_requests eval
["GET /v1/plugin/demo/control_api?json=test", "GET /v1/plugin/demo/control_api"]
--- response_body eval
["{\"msg\":\"hello\"}\n", "world"]
