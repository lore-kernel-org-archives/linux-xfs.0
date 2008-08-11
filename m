Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 13:09:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7BK989I008953
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 13:09:08 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A85E9F2A96B
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 13:10:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id YYw76YyjcybwAxzL for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 13:10:24 -0700 (PDT)
Message-ID: <48A09CA9.9080705@sandeen.net>
Date: Mon, 11 Aug 2008 15:10:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org>
In-Reply-To: <48A093A7.40606@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Linda Walsh wrote:

> This is a trimmed version of my Warn log (with boot indicators) since
>  the problems started.  I'm also unsure why some user-level processes seem
> to be dumping trace-backs periodically, including:
> 
> cifsopslock
> xfs_fsr (a few)

the explanation for xfs_fsr, at least, is the same as the last time you
brought it up ;)

http://lkml.org/lkml/2008/2/12/86

-Eric
