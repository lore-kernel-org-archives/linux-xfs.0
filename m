Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 06:13:27 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1KEDHdG017941
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 06:13:20 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 174C175A989
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 06:13:43 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id A6KH6wFMScPbkDVQ for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 06:13:43 -0800 (PST)
Message-ID: <47BC3578.5050209@sandeen.net>
Date: Wed, 20 Feb 2008 08:13:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Is CVS stable?
References: <eb736a810802200026g1b956abar922548d3e67a9682@mail.gmail.com>
In-Reply-To: <eb736a810802200026g1b956abar922548d3e67a9682@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: eric c <xcellula@gmail.com>
Cc: xfs@oss.sgi.com

eric c wrote:
> Hello,
> 
> I have recently seen some patches for slabcache related
> xfs_inode/xfs_vnode_t/dentry_cache taking up alot of memory:
>   http://oss.sgi.com/archives/xfs/2007-12/msg00154.html
>   http://oss.sgi.com/archives/xfs/2008-02/msg00138.html
> 
> If I cvs on linux-2.6-xfs, is it stable for production or bleeding?

I'd never consider any cvs head as "stable for production"

That said, the xfs cvs tree is probably one of the more stable
bleeding-edge trees you'll find. ;)

-Eric

> Thanks
> eric c
> xcellula@gmail.com
> 
> 
