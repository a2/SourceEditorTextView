//
//  ViewController.swift
//  SourceEditorTextView
//
//  Created by Alexsander Akers on 8/29/17.
//  Copyright © 2017 Pandamonia LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let textView = SourceEditorTextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.frame = view.bounds
        textView.text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Sed varius lectus ac nulla maximus, in ullamcorper erat tincidunt.
Quisque et sapien ultricies, blandit nulla at, ornare enim.
Nam at nisl a magna consequat posuere elementum at sem.
Sed sit amet arcu ultricies, tempor lacus at, tristique sapien.
Integer euismod enim sit amet quam auctor sollicitudin.
Pellentesque quis felis vel nisl fringilla accumsan in eget odio.
Mauris fermentum neque at nisl lacinia, at vulputate mi mollis.
Ut sit amet est semper, luctus leo id, aliquet mi.
Nulla sit amet sapien commodo, suscipit mi nec, euismod lectus.
Praesent id purus sit amet libero aliquet vehicula non at odio.
Quisque ultrices turpis vel ex faucibus, in euismod lectus elementum.
Aenean sit amet nulla ut turpis mollis mattis sit amet quis lorem.
Curabitur vitae augue sodales, auctor sem in, ullamcorper enim.
Nulla vitae nulla sed metus scelerisque aliquet.
Etiam bibendum ipsum eget semper tristique.
Nullam sit amet erat sit amet leo elementum sollicitudin.
Sed pellentesque mauris et purus convallis dapibus.
Morbi malesuada mi auctor sem congue malesuada.
Maecenas blandit urna at sollicitudin porttitor.
Praesent sit amet diam a magna luctus tincidunt.
Ut at mauris luctus, tempus nisl quis, euismod nibh.
Nunc sed lacus accumsan nisl egestas luctus ut at tortor.
Proin vitae ligula aliquam, venenatis augue at, sodales mi.
Integer efficitur ipsum ut libero porta, vitae ultricies quam scelerisque.
Quisque sit amet mi ac tellus auctor vestibulum.
Nulla eget quam sed massa suscipit fermentum et a augue.

"""
        view.addSubview(textView)
    }
}
