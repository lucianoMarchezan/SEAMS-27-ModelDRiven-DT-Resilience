{
  "cells": [
    {
      "position": {
        "x": 0,
        "y": 0
      },
      "size": {
        "height": 10,
        "width": 10
      },
      "type": "Statechart",
      "id": "78749915-0da0-40a2-862f-9e8d94c7c68e",
      "attrs": {
        "name": {
          "text": "reactive"
        },
        "specification": {
          "text": "@EventDriven\r\n\r\ninterface hm: \r\n    in event component_deviation\r\n    in event defect_activated\r\n    in event fault_exercised\r\n    in event error_propagated\r\n    in event impact_observed\r\n    in event threshold_violated\r\n    in event recovery\r\n    \r\n\r\ninterface bm:\r\n    in event prepare_for_sos\r\n    in event disengage_from_SoS\r\n    in event join_SoS\r\n    in event leave_SoS\r\n    in event join_constellation\r\n    in event leave_constellation\r\n    \r\n    operation announce(): void\r\n    "
        }
      },
      "z": 1
    },
    {
      "position": {
        "x": 630,
        "y": -139
      },
      "size": {
        "width": 289,
        "height": 801
      },
      "type": "Region",
      "attrs": {
        "priority": {
          "text": 1
        },
        "name": {
          "text": "Health"
        }
      },
      "id": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8",
      "z": 590,
      "embeds": [
        "e39fb634-d8c0-49c4-a4c2-cb13b85c834b",
        "7810ea71-5547-4f7f-bd33-8b241c22ff90",
        "d147c383-b451-41b9-a330-60ee698bab39",
        "64062fe3-7abf-47ea-bb2f-330774399143",
        "23de46c6-dfbf-4456-b56f-768a85d91353",
        "7bd69f8f-71b6-4295-a818-07c29043f594",
        "934d66a3-b78d-411f-9e88-8569f7a888e4",
        "ab68f1ae-6eb0-40b4-8237-0e332d59e5e4",
        "22d93ec4-cb88-485d-a0f5-66cba51eb159",
        "ecbdea8f-5f59-449f-bacd-116ead72f8b9",
        "bb91b722-7f63-4bcf-adf7-5536368aead0",
        "2ef355d0-68e5-4848-abc0-da90e17ddd83",
        "03395e68-3c1e-4da9-ac2a-80b40d5ac154",
        "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "cb845d24-467b-48e6-a2f3-4c1cf84cde0d",
        "7fbcc869-ff6f-4a1b-95c6-4557321d3441",
        "75a455d4-fc36-4986-bfd9-1773d508a43b",
        "9b3acbe5-c224-495c-98eb-835345fb5f9b",
        "bced1833-4cda-4456-89ef-d0879eb4bca3",
        "3275faa1-d7c9-49b0-8f5b-faea819c6117",
        "3d8fdf32-165f-4d38-9a38-5c9785c338d9"
      ]
    },
    {
      "position": {
        "x": 728,
        "y": -60
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Ideal",
          "fontSize": 11
        }
      },
      "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
      "z": 591,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 748,
        "y": -119
      },
      "size": {
        "height": 18,
        "width": 18
      },
      "type": "Entry",
      "entryKind": "Initial",
      "attrs": {},
      "id": "cb845d24-467b-48e6-a2f3-4c1cf84cde0d",
      "z": 592,
      "embeds": [
        "4341c1f9-98d2-4a60-807b-5a2287aced3b"
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 728,
        "y": 44
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Defective",
          "fontSize": 11
        }
      },
      "id": "7fbcc869-ff6f-4a1b-95c6-4557321d3441",
      "z": 593,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 728,
        "y": 259
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Erroneous",
          "fontSize": 11
        }
      },
      "id": "75a455d4-fc36-4986-bfd9-1773d508a43b",
      "z": 594,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 726,
        "y": 147
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Faulty",
          "fontSize": 11
        }
      },
      "id": "9b3acbe5-c224-495c-98eb-835345fb5f9b",
      "z": 595,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 720,
        "y": 490
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Degraded",
          "fontSize": 11
        }
      },
      "id": "bced1833-4cda-4456-89ef-d0879eb4bca3",
      "z": 596,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 720,
        "y": 598
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Failed",
          "fontSize": 11
        }
      },
      "id": "3275faa1-d7c9-49b0-8f5b-faea819c6117",
      "z": 597,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 709,
        "y": 388
      },
      "size": {
        "height": 60,
        "width": 90
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Malfunctioning",
          "fontSize": 11
        }
      },
      "id": "3d8fdf32-165f-4d38-9a38-5c9785c338d9",
      "z": 598,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "NodeLabel",
      "label": true,
      "size": {
        "width": 15,
        "height": 15
      },
      "position": {
        "x": 748,
        "y": -104
      },
      "attrs": {
        "label": {
          "refX": 15,
          "textAnchor": "end",
          "refY": 15,
          "textVerticalAnchor": "bottom"
        }
      },
      "id": "4341c1f9-98d2-4a60-807b-5a2287aced3b",
      "z": 612,
      "parent": "cb845d24-467b-48e6-a2f3-4c1cf84cde0d"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "3d8fdf32-165f-4d38-9a38-5c9785c338d9"
      },
      "target": {
        "id": "bced1833-4cda-4456-89ef-d0879eb4bca3",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "45%",
            "dy": "43.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.impact_observed"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "64062fe3-7abf-47ea-bb2f-330774399143",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "bced1833-4cda-4456-89ef-d0879eb4bca3"
      },
      "target": {
        "id": "3275faa1-d7c9-49b0-8f5b-faea819c6117",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "46.667%",
            "dy": "28.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.threshold_violated"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "23de46c6-dfbf-4456-b56f-768a85d91353",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "9b3acbe5-c224-495c-98eb-835345fb5f9b"
      },
      "target": {
        "id": "75a455d4-fc36-4986-bfd9-1773d508a43b",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "56.667%",
            "dy": "55%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.fault_exercised"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "22d93ec4-cb88-485d-a0f5-66cba51eb159",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "75a455d4-fc36-4986-bfd9-1773d508a43b"
      },
      "target": {
        "id": "3d8fdf32-165f-4d38-9a38-5c9785c338d9",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "53.333%",
            "dy": "70%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.error_propagated"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "d147c383-b451-41b9-a330-60ee698bab39",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7fbcc869-ff6f-4a1b-95c6-4557321d3441"
      },
      "target": {
        "id": "9b3acbe5-c224-495c-98eb-835345fb5f9b",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "46.667%",
            "dy": "30%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.defect_activated"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "ecbdea8f-5f59-449f-bacd-116ead72f8b9",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "cb845d24-467b-48e6-a2f3-4c1cf84cde0d"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "51.667%",
            "dy": "28.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "03395e68-3c1e-4da9-ac2a-80b40d5ac154",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7fbcc869-ff6f-4a1b-95c6-4557321d3441",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "93.333%",
            "dy": "60%",
            "rotate": true
          }
        },
        "priority": true
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "70%",
            "dy": "40%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.recovery"
            }
          },
          "position": {
            "distance": 0.30865266626695453,
            "offset": 34,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "bb91b722-7f63-4bcf-adf7-5536368aead0",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 842,
          "y": 80
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "3275faa1-d7c9-49b0-8f5b-faea819c6117"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "80%",
            "dy": "43.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.recovery"
            }
          },
          "position": {
            "distance": 0.08656259961408552,
            "offset": 33,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "7bd69f8f-71b6-4295-a818-07c29043f594",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 840,
          "y": 585
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "bced1833-4cda-4456-89ef-d0879eb4bca3"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "81.667%",
            "dy": "41.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.recovery"
            }
          },
          "position": {
            "distance": 0.112173528473951,
            "offset": 39.000000000000114,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "934d66a3-b78d-411f-9e88-8569f7a888e4",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 841,
          "y": 498
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "9b3acbe5-c224-495c-98eb-835345fb5f9b"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "73.333%",
            "dy": "43.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.recovery"
            }
          },
          "position": {
            "distance": 0.21989833894281105,
            "offset": 35,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "ab68f1ae-6eb0-40b4-8237-0e332d59e5e4",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 842,
          "y": 167
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4"
      },
      "target": {
        "id": "7fbcc869-ff6f-4a1b-95c6-4557321d3441",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "51.667%",
            "dy": "26.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.component_deviation"
            }
          },
          "position": {
            "distance": 0.4090909090909091,
            "offset": 3,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "2ef355d0-68e5-4848-abc0-da90e17ddd83",
      "z": 613,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "75a455d4-fc36-4986-bfd9-1773d508a43b"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "98.333%",
            "dy": "41.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.recovery"
            }
          },
          "position": {
            "distance": 0.1499055902136585,
            "offset": 34,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "7810ea71-5547-4f7f-bd33-8b241c22ff90",
      "z": 614,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 842,
          "y": 279
        },
        {
          "x": 842,
          "y": -35
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "3d8fdf32-165f-4d38-9a38-5c9785c338d9"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "100%",
            "dy": "40%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "hm.recovery"
            }
          },
          "position": {
            "distance": 0.10340253875546958,
            "offset": 37,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "e39fb634-d8c0-49c4-a4c2-cb13b85c834b",
      "z": 615,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 840,
          "y": 408
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 938,
        "y": 141
      },
      "size": {
        "width": 325,
        "height": 312
      },
      "type": "Region",
      "attrs": {
        "priority": {
          "text": 2
        },
        "name": {
          "text": "Belonging"
        }
      },
      "id": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa",
      "z": 616,
      "embeds": [
        "d66319eb-cbb3-4f17-939b-a4c3525e341c",
        "8bb05136-92fc-494a-9ed6-1b29a8a92ee8",
        "98c7e231-e9d8-4805-b1a9-0da3d19033b9",
        "f594dd83-a7dc-444a-8df9-74f1d5852113",
        "bab50da3-f64b-42f8-95f7-11e4c72b2027",
        "74b1041b-063b-49fb-a126-edab4b2d3283",
        "f49fc90b-8d64-496d-8bef-3efa119e6073",
        "278c7643-e1f6-44c2-b2a0-c83c48786346",
        "7b1028f0-5c3f-4ffe-a67e-35c439651036",
        "f1299df2-e8b4-43cd-8106-91793cbf98d4",
        "8ab39783-777b-45cc-9f81-8d6cb1cc294f",
        "1ef82dc2-0c68-4514-802f-73db7eb4e558"
      ]
    },
    {
      "position": {
        "x": 1158,
        "y": 232
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Prepared",
          "fontSize": 11
        }
      },
      "id": "278c7643-e1f6-44c2-b2a0-c83c48786346",
      "z": 619,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 1150,
        "y": 366
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Passive",
          "fontSize": 11
        }
      },
      "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036",
      "z": 620,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 970,
        "y": 358
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Active",
          "fontSize": 11
        }
      },
      "id": "f1299df2-e8b4-43cd-8106-91793cbf98d4",
      "z": 621,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "f1299df2-e8b4-43cd-8106-91793cbf98d4"
      },
      "target": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "6.667%",
            "dy": "33.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "bm.leave_constellation\n/ bm.announce"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "bab50da3-f64b-42f8-95f7-11e4c72b2027",
      "z": 630,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036"
      },
      "target": {
        "id": "f1299df2-e8b4-43cd-8106-91793cbf98d4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "89.167%",
            "dy": "80%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "bm.join_constellation\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.49166666666666664,
            "offset": -39,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "f594dd83-a7dc-444a-8df9-74f1d5852113",
      "z": 630,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036"
      },
      "target": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "10%",
            "dy": "95%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "bm.leave_SoS\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.527027027027027,
            "offset": -37,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "f49fc90b-8d64-496d-8bef-3efa119e6073",
      "z": 630,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346"
      },
      "target": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "73.333%",
            "dy": "30%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "bm.join_SoS\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.4594594594594595,
            "offset": -69,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "74b1041b-063b-49fb-a126-edab4b2d3283",
      "z": 630,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 953,
        "y": 231
      },
      "size": {
        "height": 60,
        "width": 69
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Disengaged",
          "fontSize": 11
        }
      },
      "id": "8ab39783-777b-45cc-9f81-8d6cb1cc294f",
      "z": 631,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346"
      },
      "target": {
        "id": "8ab39783-777b-45cc-9f81-8d6cb1cc294f",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "63.8%",
            "dy": "78.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "bm.disengage_from_SoS"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "8bb05136-92fc-494a-9ed6-1b29a8a92ee8",
      "z": 632,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "8ab39783-777b-45cc-9f81-8d6cb1cc294f"
      },
      "target": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "16.667%",
            "dy": "26.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "bm.prepare_for_sos"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "98c7e231-e9d8-4805-b1a9-0da3d19033b9",
      "z": 632,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 972,
        "y": 169
      },
      "size": {
        "height": 18,
        "width": 18
      },
      "type": "Entry",
      "entryKind": "Initial",
      "attrs": {},
      "id": "1ef82dc2-0c68-4514-802f-73db7eb4e558",
      "z": 633,
      "embeds": [
        "294dab23-93ec-4d81-91cd-2b37d6d5c8f2"
      ],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "NodeLabel",
      "label": true,
      "size": {
        "width": 15,
        "height": 15
      },
      "position": {
        "x": 972,
        "y": 184
      },
      "attrs": {
        "label": {
          "refX": "50%",
          "textAnchor": "middle",
          "refY": "50%",
          "textVerticalAnchor": "middle"
        }
      },
      "id": "294dab23-93ec-4d81-91cd-2b37d6d5c8f2",
      "z": 634,
      "parent": "1ef82dc2-0c68-4514-802f-73db7eb4e558"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "1ef82dc2-0c68-4514-802f-73db7eb4e558"
      },
      "target": {
        "id": "8ab39783-777b-45cc-9f81-8d6cb1cc294f",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "40.708%",
            "dy": "32.836%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "d66319eb-cbb3-4f17-939b-a4c3525e341c",
      "z": 635,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    }
  ]
}