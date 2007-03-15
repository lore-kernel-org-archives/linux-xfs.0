Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 07:24:57 -0700 (PDT)
Received: from smtp-ft4.fr.colt.net (smtp-ft4.fr.colt.net [213.41.78.208])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FENg6p002845
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 07:23:44 -0700
Date: Thu, 15 Mar 2007 15:04:22 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Should xfs_repair take this long?
Message-ID: <20070315150422.7bc5d178@harpe.intellique.com>
In-Reply-To: <45F92D8C.3090708@stsci.edu>
References: <45F92D8C.3090708@stsci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Walker <walker@stsci.edu>
Cc: xfs@oss.sgi.com

Le Thu, 15 Mar 2007 07:27:08 -0400
Thomas Walker <walker@stsci.edu> écrivait:

> xfs_repair -o assume_xfs /dev/mapper/vg0-hladata3
> 
>    This command has been running for two days now. 

Is there any output from xfs_repair ? This doesn't sound good. I've run
xfs_repair on some badly corrupted fs up to 13 TB, and it never took
more than a couple of minutes.

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
