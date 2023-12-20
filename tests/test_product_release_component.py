import modules.product_release_component as product_release_component
import modules.menu_component as menu_component


def test_canInitPRC():
    product_release_comp = product_release_component.ProductReleaseComponent()


def test_canAddNewMachineToDatabase():
    data = {"id": "2",
            "items": {
                "bento": {
                    "amount": 2,
                    "price": 10
                },
                "chips": {
                    "amount": 2,
                    "price": 10
                },
                "chocolate": {
                    "amount": 2,
                    "price": 10
                },
                "coffee": {
                    "amount": 10,
                    "price": 10
                },
                "coke": {
                    "amount": 10,
                    "price": 10
                },
                "cupcake": {
                    "amount": 10,
                    "price": 10
                },
                "dried_fruits": {
                    "amount": 10,
                    "price": 10
                },
                "granular_bars": {
                    "amount": 10,
                    "price": 10
                },
                "gummies": {
                    "amount": 10,
                    "price": 10
                },
                "ice_cream": {
                    "amount": 10,
                    "price": 10
                },
                "instant_cup_noodle": {
                    "amount": 10,
                    "price": 10
                },
                "nuts": {
                    "amount": 10,
                    "price": 10
                },
                "orange_juice": {
                    "amount": 10,
                    "price": 10
                },
                "popcorn": {
                    "amount": 10,
                    "price": 10
                },
                "salads": {
                    "amount": 10,
                    "price": 10
                },
                "sandwiches": {
                    "amount": 10,
                    "price": 10
                },
                "soda": {
                    "amount": 10,
                    "price": 10
                },
                "sweet_candy": {
                    "amount": 10,
                    "price": 10
                },
                "tea": {
                    "amount": 10,
                    "price": 10
                },
                "water": {
                    "amount": 10,
                    "price": 10
                }
            }}
    product_release_comp = product_release_component.ProductReleaseComponent()
    product_release_comp.addNewMachineToDatabase(data)
    menu_comp = menu_component.MenuComponent()
    menu_comp.queryMenuByMachineIDFromDatabase("2")
    items = menu_comp.queryMenuByMachineIDFromDatabase("2")
    assert items == {
        "bento": {
            "amount": 2,
            "price": 10
        },
        "chips": {
            "amount": 2,
            "price": 10
        },
        "chocolate": {
            "amount": 2,
            "price": 10
        },
        "coffee": {
            "amount": 10,
            "price": 10
        },
        "coke": {
            "amount": 10,
            "price": 10
        },
        "cupcake": {
            "amount": 10,
            "price": 10
        },
        "dried_fruits": {
            "amount": 10,
            "price": 10
        },
        "granular_bars": {
            "amount": 10,
            "price": 10
        },
        "gummies": {
            "amount": 10,
            "price": 10
        },
        "ice_cream": {
            "amount": 10,
            "price": 10
        },
        "instant_cup_noodle": {
            "amount": 10,
            "price": 10
        },
        "nuts": {
            "amount": 10,
            "price": 10
        },
        "orange_juice": {
            "amount": 10,
            "price": 10
        },
        "popcorn": {
            "amount": 10,
            "price": 10
        },
        "salads": {
            "amount": 10,
            "price": 10
        },
        "sandwiches": {
            "amount": 10,
            "price": 10
        },
        "soda": {
            "amount": 10,
            "price": 10
        },
        "sweet_candy": {
            "amount": 10,
            "price": 10
        },
        "tea": {
            "amount": 10,
            "price": 10
        },
        "water": {
            "amount": 10,
            "price": 10
        }
    }


def test_canUpdateProductListToDatabase():
    data = {"id": "2",
            "items": {
                "bento": {
                    "amount": 5,
                    "price": 10
                },
                "chips": {
                    "amount": 5,
                    "price": 10
                },
                "chocolate": {
                    "amount": 5,
                    "price": 10
                },
                "coffee": {
                    "amount": 10,
                    "price": 10
                },
                "coke": {
                    "amount": 10,
                    "price": 10
                },
                "cupcake": {
                    "amount": 10,
                    "price": 10
                },
                "dried_fruits": {
                    "amount": 10,
                    "price": 10
                },
                "granular_bars": {
                    "amount": 10,
                    "price": 10
                },
                "gummies": {
                    "amount": 10,
                    "price": 10
                },
                "ice_cream": {
                    "amount": 10,
                    "price": 10
                },
                "instant_cup_noodle": {
                    "amount": 10,
                    "price": 10
                },
                "nuts": {
                    "amount": 10,
                    "price": 10
                },
                "orange_juice": {
                    "amount": 10,
                    "price": 10
                },
                "popcorn": {
                    "amount": 10,
                    "price": 10
                },
                "salads": {
                    "amount": 10,
                    "price": 10
                },
                "sandwiches": {
                    "amount": 10,
                    "price": 10
                },
                "soda": {
                    "amount": 10,
                    "price": 10
                },
                "sweet_candy": {
                    "amount": 10,
                    "price": 10
                },
                "tea": {
                    "amount": 10,
                    "price": 10
                },
                "water": {
                    "amount": 10,
                    "price": 10
                }
            }}
    product_release_comp = product_release_component.ProductReleaseComponent()
    product_release_comp.updateProductListToDatabase(data["id"], data["items"])
    menu_comp = menu_component.MenuComponent()
    menu_comp.queryMenuByMachineIDFromDatabase("2")
    items = menu_comp.queryMenuByMachineIDFromDatabase("2")
    assert items == {
        "bento": {
            "amount": 5,
            "price": 10
        },
        "chips": {
            "amount": 5,
            "price": 10
        },
        "chocolate": {
            "amount": 5,
            "price": 10
        },
        "coffee": {
            "amount": 10,
            "price": 10
        },
        "coke": {
            "amount": 10,
            "price": 10
        },
        "cupcake": {
            "amount": 10,
            "price": 10
        },
        "dried_fruits": {
            "amount": 10,
            "price": 10
        },
        "granular_bars": {
            "amount": 10,
            "price": 10
        },
        "gummies": {
            "amount": 10,
            "price": 10
        },
        "ice_cream": {
            "amount": 10,
            "price": 10
        },
        "instant_cup_noodle": {
            "amount": 10,
            "price": 10
        },
        "nuts": {
            "amount": 10,
            "price": 10
        },
        "orange_juice": {
            "amount": 10,
            "price": 10
        },
        "popcorn": {
            "amount": 10,
            "price": 10
        },
        "salads": {
            "amount": 10,
            "price": 10
        },
        "sandwiches": {
            "amount": 10,
            "price": 10
        },
        "soda": {
            "amount": 10,
            "price": 10
        },
        "sweet_candy": {
            "amount": 10,
            "price": 10
        },
        "tea": {
            "amount": 10,
            "price": 10
        },
        "water": {
            "amount": 10,
            "price": 10
        }
    }
