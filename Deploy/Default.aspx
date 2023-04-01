<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RegisterUser.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đăng kí tài khoản</title>
    <style>
        * {
            box-sizing: border-box
        }

        /* Add padding to containers */
        .container {
            padding: 16px;
        }

        /* Full-width input fields */
        input[type=text], input[type=password] {
            width: 100%;
            padding: 9px;
           /* margin: 5px 0 22px 0;*/
            display: inline-block;
            border: none;
            background: #f1f1f1;
        }

            input[type=text]:focus, input[type=password]:focus {
                background-color: #ddd;
                outline: none;
            }

        /* Overwrite default styles of hr */
        hr {
            border: 1px solid #f1f1f1;
            margin-bottom: 25px;
        }

        /* Set a style for the submit/register button */
        .registerbtn {
            background-color: #04AA6D;
            color: white;
            padding: 16px 20px;
            margin: 8px 0;
            border: none;
            cursor: pointer;
            width: 100%;
            opacity: 0.9;
        }

            .registerbtn:hover {
                opacity: 1;
            }

        /* Add a blue text color to links */
        a {
            color: dodgerblue;
        }

        /* Set a grey background color and center the text of the "sign in" section */
        .signin {
            background-color: #f1f1f1;
            text-align: center;
        }
        .glyphicon-ok {
            color: green
        }

        .glyphicon-remove {
            color: red
        }
        .error {
            color: red !important;
            font-style: italic;
            font-size: 11px;
        }
    </style>
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="//code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.5/jquery.validate.min.js" integrity="sha512-rstIgDs0xPgmG6RX1Aba4KV5cWJbAMcvRCVmglpam9SoHZiUCyQVDdH2LPlxoHtrv17XWblE/V/PP+Tr04hbtA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script>
        // Config register form
        $().ready(function () {
            $.validator.addMethod("IsPasswordFormat", function (value) {
                var hasWSpace = value.indexOf(' ') >= 0;
                return !hasWSpace
            }, '')
            $.validator.addMethod("IsAlphaNumeric", function (value) {
                return /^[a-zA-Z0-9]+$/.test(value)
            }, '')

            $('#txtUsername').on('blur mouseout', function () {
                var val = $.trim($(this).val())
                $(this).val(val)
            });
            $('#txtPassword').on('blur mouseout', function () {
                var val = $.trim($(this).val())
                $(this).val(val)
            });
            $('#txtVerifyPwd').on('blur mouseout', function () {
                var val = $.trim($(this).val())
                $(this).val(val)
            });

            $('#btnRefreshCaptcha').click(function () {
                var imgCaptcha = $('img').eq(0)
                var src = imgCaptcha.attr('src')
                imgCaptcha.attr('src', src + "?r=" + new Date().getTime())
            })
            $("form").on("submit", function (event) {
                event.preventDefault();
            })
            $.validator.setDefaults({
                submitHandler: function (form) {
                    $('form').each(function () {
                        this.value = $(this).val().trim();
                    })
                    register(form)
                }
            });
            $('#formReg').validate({
                rules: {
                    txtUsername: {
                        required: true,
                        minlength: 3,
                        maxlength: 12,
                        IsAlphaNumeric: true,
                        remote: {
                            type: 'post',
                            url: 'register.aspx?cmd=CheckUsername',
                            data: {
                                'txtUsername': function () { return $('#txtUsername').val(); }
                            },
                            dataType: 'json'
                        }
                    },
                    txtPassword: {
                        required: true,
                        minlength: 8,
                        IsPasswordFormat: true
                    },
                    txtVerifyPwd: {
                        required: true,
                        equalTo: "#txtPassword"
                    },
                    txtCode: {
                        required: true,
                        minlength: 6,
                        maxlength: 6,
                    },
                },
                messages: {
                    txtUsername: {
                        required: 'username không được trống',
                        minlength: jQuery.validator.format('userName phải có ít nhất {0} kí tự'),
                        maxlength: jQuery.validator.format('userName không quá {0} ký tự'),
                        IsAlphaNumeric: 'username có kí tự không hợp lệ',
                        remote:'username đã được đăng ký trước đó'
                    },
                    txtPassword: {
                        required: 'Password không được trống',
                        minlength: jQuery.validator.format('Password tối thiểu {0} kí tự.'),
                        IsPasswordFormat: 'Password phải bao gồm kí tự và số và không có khoảng trắng !'
                    },
                    txtVerifyPwd: {
                        required: 'Password nhập lại không được trống.',
                        equalTo: 'Password nhập lại không giống nhau.',
                    },
                    txtCode: {
                        required: 'Mã bảo vệ không được trống',
                        minlength: jQuery.validator.format('Mã bảo vệ phải có ít nhất {0} kí tự'),
                        maxlength: jQuery.validator.format('Mã bảo vệ không quá {0} ký tự'),
                    }
                },
                errorElement: "em",
                errorPlacement: function (error, element) {
                    // Add the `help-block` class to the error element
                    error.addClass("help-block");

                    // Add `has-feedback` class to the parent div.form-group
                    // in order to add icons to inputs
                    element.parents(".col-sm-5").addClass("has-feedback");

                    if (element.prop("type") === "checkbox") {
                        error.insertAfter(element.parent("label"));
                    } else {
                        error.insertAfter(element);
                    }
                    // Add the span element, if doesn't exists, and apply the icon classes to it.
                    if (!element.next("span")[0]) {
                        $("<span class='glyphicon glyphicon-remove form-control-feedback'></span>").insertAfter(element);
                    }
                },
                success: function (label, element) {
                    // Add the span element, if doesn't exists, and apply the icon classes to it.
                    if (!$(element).next("span")[0]) {
                        $("<span class='glyphicon glyphicon-ok form-control-feedback'></span>").insertAfter($(element));
                    }
                },
                highlight: function (element, errorClass, validClass) {
                    $(element).parents(".col-sm-5").addClass("has-error").removeClass("has-success");
                    $(element).next("span").addClass("glyphicon-remove").removeClass("glyphicon-ok");
                },
                unhighlight: function (element, errorClass, validClass) {
                    $(element).parents(".col-sm-5").addClass("has-success").removeClass("has-error");
                    $(element).next("span").addClass("glyphicon-ok").removeClass("glyphicon-remove");
                }
            });
        })
    </script>
    <script>
        $.fn.serializeAndEncode = function () {
            return $.map(this.serializeArray(), function (val) {
                return [val.name, encodeURIComponent(val.value)].join('=');
            }).join('&');
        };
        function register(form) {
            var cmd = 'Register';
            var data = toJSON($('#' + form.id).serializeAndEncode());
            $.ajax({
                type: 'POST',
                url: '/Register.aspx',
                data: $.extend({ cmd: cmd }, data),
                success: function (responseText) {
                    var rs = responseText;
                    if (rs.success) {
                        $('#txtCodeCheckUser').val('');
                        $('#txtCode').val('');
                        $('#btnRefreshCapcha').trigger('click');
                        $('form')[0].reset();
                        alert('Đăng kí thành công')
                    }
                    else alert(rs.msg)
                },
                error: function (e) {
                    alert(e.responseText)
                }
            })
        }
        function toJSON(queryString) {
            var pairs = queryString.split('&');
            var result = {};
            pairs.forEach(function (pair) {
                pair = pair.split('=');
                result[pair[0]] = decodeURIComponent(pair[1] || '');
            });
            return JSON.parse(JSON.stringify(result));
        }
    </script>
    <%if (isTestMode) { %>
        <script>
            $().ready(function () {
                (function () {
                    var rd = new Date().getTime().toString();
                    $('#txtUsername').val('test' + rd.substr((rd.length - 3), 3))
                    $('#txtPassword').val('00000000')
                    $('#txtVerifyPwd').val($('#txtPassword').val())
                    $.ajax({
                        type: 'GET',
                        url: '/Register.aspx',
                        data: { cmd: 'GetCode' },
                        success: function (responseText) {
                            $('#txtCode').val(responseText);
                        }
                    })
                })()
            })
        </script>
    <%} %>
</head>
<body>
    <form id="formReg" style="width:50%">
        <div class="container">
            <h1>Đăng Ký</h1>
            <%--<p>Please fill in this form to create an account.</p>--%>
            <hr>
            
            <label for="email"><b>TÊN TÀI KHOẢN</b></label>
            <div style="position:relative">
                <input type="text" placeholder="nhập tài khoản không viết in hoa" name="txtUsername" id="txtUsername" required />
            </div>
            <label for="psw"><b>MẬT KHẨU</b></label>
            <div style="position:relative">
                <input type="password" placeholder="nhập mật khẩu của bạn" name="txtPassword" id="txtPassword" required />
            </div>
            <label for="psw-repeat"><b>NHẬP LẠI MẬT KHẨU</b></label>
            <div style="position:relative">
                <input type="password" placeholder="nhập lại mật khẩu ở trên" name="txtVerifyPwd" id="txtVerifyPwd" required />
            </div>
            <hr/>
             <label for="psw-repeat"><b>MÃ BẢO VỆ</b> : <img id="imgCaptchaLong" alt="" src="Captcha.aspx?r=<%=new Random().Next()%>" width="130" height="30" /><button id="btnRefreshCaptcha" class="btn btn-default" type="button" style="border:none; box-shadow:none;">
                            <i class="fa fa-refresh" aria-hidden="true" style="color:#000"></i></button></label>
            <div style="position:relative">
                <input name="txtCode" id="txtCode" placeholder="Nhập mã bảo vệ" type="text" class="form-control" maxlength="10" />
            </div>
           <%-- <p>By creating an account you agree to our <a href="#">Terms & Privacy</a>.</p>--%>
            <button type="submit" class="registerbtn">ĐĂNG KÝ</button>
        </div>

        <%--<div class="container signin">
            <p>Already have an account? <a href="#">Sign in</a>.</p>
        </div>--%>
    </form>
</body>
</html>
