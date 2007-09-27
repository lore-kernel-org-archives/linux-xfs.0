Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 19:51:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8R2p7Lq012451
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 19:51:08 -0700
Message-ID: <46FB1A9A.7020101@sandeen.net>
Date: Wed, 26 Sep 2007 21:51:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 971050 - Remove linux-2.4 build support
References: <20070926082120.86D772FB966D@linuxbuild.melbourne.sgi.com>
In-Reply-To: <20070926082120.86D772FB966D@linuxbuild.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: donaldd@sgi.com
Cc: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

donaldd@sgi.com wrote:
> Remove linux-2.4 Makefile wrappers from fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.
> 
> Date:  Wed Sep 26 18:20:13 AEST 2007
> Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
> Inspected by:  tes,vapo
> 
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
> 
> 
> Modid:  xfs-linux-melb:xfs-kern:29784a

support/Makefile can go away too, it's 2.4 only.

-Eric
