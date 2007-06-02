Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Jun 2007 15:53:02 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l52MqwWt032611
	for <linux-xfs@oss.sgi.com>; Sat, 2 Jun 2007 15:52:59 -0700
Date: Sat, 2 Jun 2007 23:04:03 +0100 (BST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: corruption bug in 2.6.17
In-Reply-To: <5d96567b0706021407q4455b60asd9d23ef82cb90b55@mail.gmail.com>
Message-ID: <alpine.DEB.0.99.0706022300140.16496@sheep.housecafe.de>
References: <5d96567b0706021407q4455b60asd9d23ef82cb90b55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com, alkirkco@sgi.com

On Sun, 3 Jun 2007, Raz Ben-Jehuda(caro) wrote:
> when I tried to create a new file I got the bellow oops.
> could it be that your fix for 2.6.17.7 solves this problem ?

If you're running a 2.6.17 kernel (< 2.6.17.7) when you're getting these 
errors, I guess it's most likely this particular 2.6.17-bug. Please read 
http://oss.sgi.com/projects/xfs/faq.html#dir2 very carefully and upgrade 
xfsprogs and your kernel.

C.
-- 
BOFH excuse #55:

Plumber mistook routing panel for decorative wall fixture
