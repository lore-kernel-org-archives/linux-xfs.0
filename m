Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 22:38:01 -0700 (PDT)
Received: from outbound4.mail.tds.net (outbound4.mail.tds.net [216.170.230.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T5bttL015778
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 22:37:56 -0700
Date: Thu, 28 Jun 2007 08:27:54 -0500 (CDT)
From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
In-Reply-To: <20070628090551.GG4504@mea-ext.zmailer.org>
Message-ID: <Pine.LNX.4.64.0706280827170.5806@gheavc.wnzcbav.cig>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <46832E60.9000006@rabbit.us> <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan>
 <46837056.4050306@rabbit.us> <20070628090551.GG4504@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Peter Rabbitson <rabbit@rabbit.us>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

On Thu, 28 Jun 2007, Matti Aarnio wrote:

> I do have LVM in between the MD-RAID5 and XFS, so I did also align
> the LVM to that  3 * 256k.

How did you align the LVM ?


--
Jon Nelson <jnelson-linux-raid@jamponi.net>
