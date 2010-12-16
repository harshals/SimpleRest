/* Created by jankoatwarpspeed.com */

(function($) {
    $.fn.formToWizard = function(options) {
        options = $.extend({  
            submitButton: "",
            element: "",
            usePanel: true,
            buttonPanelNames:[],
            buttonPanelIds:[]
        }, options); 
        
        var element = this;

        var steps = $(element).find(options.element);
        var count = steps.size();
        var submmitButtonName = "#" + options.submitButton;
        $(submmitButtonName).hide();

        // 2
        $(element).before("<ul id='steps'></ul>");

        steps.each(function(i) {
            $(this).wrap("<div id='step" + i + "'></div>");
            $(this).append("<p id='step" + i + "commands'></p>");

            // 2
            var name = $(this).find("legend").html();
            $("#steps").append("<li id='stepDesc" + i + "'>Step " + (i + 1) + "<span>" + name + "</span></li>");
            
            $("#steps").find("li#stepDesc" + i).bind("click", function(e) {

                selectStep(i);
            });

            if (i == 0) {
                
                createNextButton(i);
                selectStep(i);
            }
            else if (i == count - 1) {
                $("#step" + i).hide();
                createPrevButton(i);
            }
            else {
                $("#step" + i).hide();
                createPrevButton(i);
                createNextButton(i);
            }
        });
        
        if (options.usePanel) {

            $("#steps").prepend("<li id='stepPrev' ><span class='prev'> Prev </span></li>");
            $("#steps").append("<li id='stepNext' ><span class='next'>Nxt</span></li>");

            $("#steps").append("<li class='ButtonPanel' ></li>");
			/*
            $("#steps").append("<li class='ui-state-default ui-corner-all' ></li>");
            $("#steps li.ui-state-default").append("<span class='ui-icon ui-icon-circle-check' id='SaveButton'>Save</span>");
            $("#steps li.ui-state-default").append("<span class='ui-icon ui-icon-circle-close' id='DeleteButton'>Cancel</span>");
            $("#steps li.ui-state-default").append("<span class='ui-icon ui-icon-print' id='PrintButton'>Print</span>");
			*/
            $.each(options.buttonPanelIds, function(i,buttonId) {
                
                $("#steps li.ButtonPanel").append("<a id='" 
                                                    + buttonId 
                                                    +"' class='Buttons'>" 
                                                    + options.buttonPanelNames[i] 
                                                    + "</a><br>");
            });
            /*
            $("#steps li.ButtonPanel").append("<a id='DeleteLink' class='Buttons'>Delete</a><br>");
            $("#steps li.ButtonPanel").append("<a id='PrintLink' class='Buttons'>Print</a><br>");
*/
            $("#stepNext span").bind("click", function(e) {

                    var currentStep = $("#steps").find("li.current").attr("id").replace("stepDesc","");
                    if (parseInt(currentStep) < (count -1) ) 
                    selectStep((parseInt(currentStep) + 1));
            });
            $("#stepPrev span").bind("click", function(e) {

                    var currentStep = $("#steps").find("li.current").attr("id").replace("stepDesc","");
                    if (parseInt(currentStep) > 0) 
                    selectStep((parseInt(currentStep) - 1));
            });
        }
        
        function createPrevButton(i) {
        
            if (options.usePanel)
                return;

            var stepName = "step" + i;
            $("#" + stepName + "commands").append("<a href='#' id='" + stepName + "Prev' class='prev'>< Back</a>");
            
            $("#" + stepName + "Prev").bind("click", function(e) {
                $("#" + stepName).hide();
                $("#step" + (i - 1)).show();
                $(submmitButtonName).hide();
                selectStep(i - 1);
            });
        }

        function createNextButton(i) {

            if (options.usePanel)
                return;
            var stepName = "step" + i;
            $("#" + stepName + "commands").append("<a href='#' id='" + stepName + "Next' class='next'>Next ></a>");

            $("#" + stepName + "Next").bind("click", function(e) {
                $("#" + stepName).hide();
                $("#step" + (i + 1)).show();
                if (i + 2 == count)
                    $(submmitButtonName).show();
                selectStep(i + 1);
            });
        }

        function selectStep(i) {
            $("#steps li").removeClass("current");
            $("#stepDesc" + i).addClass("current");
            
            var stepName = "step" + i;
            if (options.usePanel) {

                $("div[id^=step]").hide();
                $("#step" + i ).show();
                
            }
        }
    }
})(jQuery); 
