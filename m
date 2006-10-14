Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Oct 2006 21:32:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9E4WWaG028947
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 21:32:33 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4322E4A361A
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 21:31:49 -0700 (PDT)
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id CA8841809E77A
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 23:31:48 -0500 (CDT)
Message-ID: <45306834.5050008@sandeen.net>
Date: Fri, 13 Oct 2006 23:31:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Make stuff static
References: <20060929032856.8DA9C18001A5E@sandeen.net>
In-Reply-To: <20060929032856.8DA9C18001A5E@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

sandeen@sandeen.net wrote:
> Make things static which can be.
> 
>  linux-2.4/xfs_vfs.c   |    2 -
>  linux-2.4/xfs_vfs.h   |    1 
>  linux-2.4/xfs_vnode.c |    2 -
>  linux-2.6/xfs_vfs.c   |    2 -
>  linux-2.6/xfs_vfs.h   |    1 
>  linux-2.6/xfs_vnode.c |    2 -
>  quota/xfs_dquot.c     |    2 -
>  quota/xfs_qm_bhv.c    |    2 -
>  xfs_attr.c            |    3 +-

....

Ugh, forgot a quilt refresh, there are a couple files missing here.

Is there any interest in this change?  if so I'll send the update.

Thanks,

-Eric
