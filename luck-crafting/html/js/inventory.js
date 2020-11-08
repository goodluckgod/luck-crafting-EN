var type = "normal";
var lastCraft = {};
var disabled = false;
var disabledFunction = null;

var closekeys = new Object();
closeKeys = [113, 27, 90]; //Array of keys used to close inventory. Default ESC and F2. Check https://keycode.info/ to get your key code

window.addEventListener("message", function (event) {
    if (event.data.action == "setWeight") {
        $(".weight").html(event.data.text);
    } else if (event.data.action == "setWeightSecondary") {
        $(".weightsecondary").html(event.data.text);
    } else if (event.data.action == "display") {
        type = event.data.type
        disabled = false;

        $(".infoplayer-div").html(event.data.text);
        
        

        $(".ui").fadeIn();
    } else if (event.data.action == "hide") {
        $("#dialog").dialog("close");
        $(".ui").fadeOut();
        $(".item").remove();
    } else if (event.data.action == "setItems") {
        inventorySetup(event.data.itemList, event.data.craftItems);

        $('.item').draggable({
            helper: 'clone',
            appendTo: 'body',
            zIndex: 100,
            revert: 'invalid',
            start: function (event, ui) {
                if (disabled) {
                    return false;
                }

                $(this).css('background-image', 'none');
                itemData = $(this).data("item");
                itemInventory = $(this).data("inventory");
            },
            stop: function () {
                itemData = $(this).data("item");

                if (itemData !== undefined && itemData.name !== undefined) {
                    $(this).css('background-image', 'url(\'img/items/' + itemData.name + '.png\'');
                    $("#use").removeClass("disabled");
                    $("#give").removeClass("disabled");
                }
            }
        });
        } else if (event.data.action == "setCraftItem") {
            craftedSetup(event.data.item);
        }
});


function closeCrafting() {
    $.post("http://luck-crafting/closeCrafting", JSON.stringify({}));
}

function craftedSetup(item) {
            $('#craftedItemSlot').html('<div class="item-count">'+ item.item.count +'</div><div class="item-name">'+ item.text +'</div>');
            $('#craftedItemSlot').css("background-image", 'url(\'img/items/' + item.item.name + '.png\')');
            $('#craftedItemSlot').data('item', item.item);
            $('#craftedItemSlot').data('inventory', "crafted");
}


function inventorySetup(items, craftItems) {
    $("#playerInventory").html("");
    $.each(items, function (index, item) {
       
        if (item != null) {
            count = item.count
        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
        $('#playerInventory .slot').on('contextmenu', function (evt) {
            evt.preventDefault();
        });
    }
        
        $('#playerInventory .slot').mouseup(function (evt) {
          if (evt.which === 3 && evt.shiftKey) { // right-click + shift
            if (!disabled) {
                item.count = $('#item-' + index).data("item").count;
                transftootherinv(item);
            }
          }
        });
    });

    $("#CraftItems").html("");
    $("#CraftItems2").html("");
    $("#CraftItems3").html("");
    $("#CraftedItem").html("");
    var i;
    for (i = 1; i < 4; i++) {
        $("#CraftItems").append('<div class="craftItemSlot"><div id="craftItemSlot-'+ i +'" class="item" ><div class="craftSlotId">' + i + '</div><div class="item-count"></div><div class="item-name"></div></div><div class="item-name-bg"></div></div>');
    }
    for (i = 4; i < 7; i++) {
        $("#CraftItems2").append('<div class="craftItemSlot"><div id="craftItemSlot-'+ i +'" class="item" ><div class="craftSlotId">' + i + '</div><div class="item-count"></div><div class="item-name"></div></div><div class="item-name-bg"></div></div>');
    }
    for (i = 7; i < 10; i++) {
        $("#CraftItems3").append('<div class="craftItemSlot"><div id="craftItemSlot-'+ i +'" class="item" ><div class="craftSlotId">' + i + '</div><div class="item-count"></div><div class="item-name"></div></div><div class="item-name-bg"></div></div>');
    }
    $("#CraftedItem").append('<div class="craftedItemSlot"><div id="craftedItemSlot" class="item" ></div><div class="item-count"></div><div class="item-name"></div></div><div class="item-name-bg"></div></div>');
    $.each(craftItems, function(index, item) {
        if (item != null) {
            count = setCount(item);
            $('#craftItemSlot-' + item.slot).html('</div><div class="item-count">'+ count +'</div><div class="item-name">'+ item.label +'</div>');
            $('#craftItemSlot-' + item.slot).css("background-image", 'url(\'img/items/' + item.name + '.png\')');
            $('#craftItemSlot-' + item.slot).data('item', item);
            $('#craftItemSlot-' + item.slot).data('inventory', "craft");
        }
    });
    makeDraggablesCraft()
}

function makeDraggablesCraft() {
    $('#craftItemSlot-1').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");
            if (itemInventory === "main" || itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/PutIntoCraft", JSON.stringify({
                    item: itemData,
                    slot: 1,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
    $('#craftItemSlot-2').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (itemInventory === "main" || itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/PutIntoCraft", JSON.stringify({
                    item: itemData,
                    slot: 2,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
    $('#craftItemSlot-3').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (itemInventory === "main" || itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/PutIntoCraft", JSON.stringify({
                    item: itemData,
                    slot: 3,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
    $('#craftItemSlot-4').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (itemInventory === "main" || itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/PutIntoCraft", JSON.stringify({
                    item: itemData,
                    slot: 4,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
    $('#craftItemSlot-5').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (itemInventory === "main" || itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/PutIntoCraft", JSON.stringify({
                    item: itemData,
                    slot: 5,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
        $('#craftItemSlot-6').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (itemInventory === "main" || itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/PutIntoCraft", JSON.stringify({
                    item: itemData,
                    slot: 6,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
    $('#craftItemSlot-7').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (itemInventory === "main" || itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/PutIntoCraft", JSON.stringify({
                    item: itemData,
                    slot: 7,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
    $('#craftItemSlot-8').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (itemInventory === "main" || itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/PutIntoCraft", JSON.stringify({
                    item: itemData,
                    slot: 8,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
    $('#craftItemSlot-9').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (itemInventory === "main" || itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/PutIntoCraft", JSON.stringify({
                    item: itemData,
                    slot: 9,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
}







function CraftItem() {
        disableInventory(300);
        $.post("http://luck-crafting/CraftLastItem", {});
}

function refreshCraft() {
    disableInventory(300);
    $.post("http://luck-crafting/refreshCraft", {});
}


function Interval(time) {
    var timer = false;
    this.start = function () {
        if (this.isRunning()) {
            clearInterval(timer);
            timer = false;
        }

        timer = setInterval(function () {
            disabled = false;
        }, time);
    };
    this.stop = function () {
        clearInterval(timer);
        timer = false;
    };
    this.isRunning = function () {
        return timer !== false;
    };
}

function disableInventory(ms) {
    disabled = true;

    if (disabledFunction === null) {
        disabledFunction = new Interval(ms);
        disabledFunction.start();
    } else {
        if (disabledFunction.isRunning()) {
            disabledFunction.stop();
        }

        disabledFunction.start();
    }
}

function setCount(item) {
    count = item.count

    return count;
}

function setCost(item) {
    cost = item.price

    if (item.price == 0){
        cost = "$" + item.price
    }
    if (item.price > 0) {
        cost = "$" + item.price
    }
    return cost;
}


$(document).ready(function () {
    $("#count").focus(function () {
        $(this).val("")
    }).blur(function () {
        if ($(this).val() == "" || Number($(this).val()) < 0) {
            $(this).val("0")
        }
    });

    $("body").on("keyup", function (key) {
        if (closeKeys.includes(key.which)) {
            closeCrafting();
        }
    });

 
	
    $('#playerInventory').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");
             
            if (itemInventory === "craft") {
                disableInventory(300);
                $.post("http://luck-crafting/TakeFromCraft", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }

            if (itemInventory === "crafted") {
                disableInventory(300);
                $.post("http://luck-crafting/TakeFromCrafted", JSON.stringify({
                }));
            }
        }
    });
    



    $("#count").on("keypress keyup blur", function (event) {
        $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });
});

$.widget('ui.dialog', $.ui.dialog, {
    options: {
        // Determine if clicking outside the dialog shall close it
        clickOutside: false,
        // Element (id or class) that triggers the dialog opening 
        clickOutsideTrigger: ''
    },
    open: function () {
        var clickOutsideTriggerEl = $(this.options.clickOutsideTrigger),
            that = this;
        if (this.options.clickOutside) {
            // Add document wide click handler for the current dialog namespace
            $(document).on('click.ui.dialogClickOutside' + that.eventNamespace, function (event) {
                var $target = $(event.target);
                if ($target.closest($(clickOutsideTriggerEl)).length === 0 &&
                    $target.closest($(that.uiDialog)).length === 0) {
                    that.close();
                }
            });
        }
        // Invoke parent open method
        this._super();
    },
    close: function () {
        // Remove document wide click handler for the current dialog
        $(document).off('click.ui.dialogClickOutside' + this.eventNamespace);
        // Invoke parent close method 
        this._super();
    },
});