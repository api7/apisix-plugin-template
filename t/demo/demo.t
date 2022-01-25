use t::APISIX 'no_plan';

repeat_each(1);
no_long_string();
no_root_location();

add_block_preprocessor(sub {
    my ($block) = @_;

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
