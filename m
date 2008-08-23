Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 17:39:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7N0dGQD030003
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 17:39:16 -0700
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D3103C474A
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 17:40:37 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.177]) by cuda.sgi.com with ESMTP id esyCYF2BbGURaexf for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 17:40:37 -0700 (PDT)
Date: Sat, 23 Aug 2008 02:40:34 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: xfs_quota free
In-Reply-To: <48AF4DD1.5080603@nerp.net>
Message-ID: <alpine.DEB.1.10.0808230239110.20126@sheep.housecafe.de>
References: <48AF4DD1.5080603@nerp.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dan <dan@nerp.net>
Cc: xfs@oss.sgi.com

On Fri, 22 Aug 2008, Dan wrote:
> data is on /dev/sdb.  Basically it boils down to xfs_quota -c 'free -r -h' 
> /mnt I think but I get the following error:
>
> XFS_IOC_FSGEOMETRY_V1: Invalid argument

A similar issue has been reported in http://lists.xensource.com/archives/html/xen-users/2007-10/msg00577.html

Which kernel are you running?

C.
-- 
BOFH excuse #266:

All of the packets are empty.
