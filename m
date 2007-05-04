Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 15:12:33 -0700 (PDT)
Received: from postfix2-g20.free.fr (postfix2-g20.free.fr [212.27.60.43])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l44MCTfB015022
	for <linux-xfs@oss.sgi.com>; Fri, 4 May 2007 15:12:30 -0700
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix2-g20.free.fr (Postfix) with ESMTP id 48027FA5D2B
	for <linux-xfs@oss.sgi.com>; Fri,  4 May 2007 22:44:22 +0200 (CEST)
Date: Fri, 4 May 2007 23:43:57 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS crash on linux raid
Message-ID: <20070504234357.24d22883@galadriel.home>
In-Reply-To: <200705041758.21320.Martin@lichtvoll.de>
References: <20070503164521.16efe075@harpe.intellique.com>
	<20070504073344.GL32602149@melbourne.sgi.com>
	<20070504152546.614374ac@harpe.intellique.com>
	<200705041758.21320.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Le Fri, 4 May 2007 17:58:21 +0200 vous écriviez:

> Did you test with ext3 as well? You wrote it crashes with ReiserFS 
> (version 3) even faster. When it crashes with several filesystems its 
> unlikely to be a filesystem issue.

Unfortunately ext3 doesn't support volumes bigger than 8TB, so that's
useless to me. I plan to test jfs, however.
I think it's more a dm/md issue, but I'm not sure...

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
