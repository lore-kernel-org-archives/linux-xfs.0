Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 19:23:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA12N99l005006
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 19:23:10 -0700
Message-ID: <472939AD.9080708@sandeen.net>
Date: Wed, 31 Oct 2007 21:27:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com> <20071031233516.GB88034736@melbourne.sgi.com>
In-Reply-To: <20071031233516.GB88034736@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

Niv Sardi wrote:

> Eric: mkfs.conf sounds like a great idea to me, but i don't think it should
> be exclusive to XFS.

It's not, ext[234] already has it :)

It'd have to be specific to each mkfs, I think, since each mkfs has its 
own knobs.

-Eric
