Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 May 2008 08:38:49 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4OFckGK006442
	for <xfs@oss.sgi.com>; Sat, 24 May 2008 08:38:47 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 091DE172AD0A
	for <xfs@oss.sgi.com>; Sat, 24 May 2008 08:39:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id geUVH1LTjInhedUB for <xfs@oss.sgi.com>; Sat, 24 May 2008 08:39:37 -0700 (PDT)
Message-ID: <483836B6.8030406@sandeen.net>
Date: Sat, 24 May 2008 10:39:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: RFI for 2.6.25.5 : Re: Regression- XFS won't mount on partitioned
 md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net> <482FED60.7060405@dgreaves.com> <4838192F.3050004@dgreaves.com> <20080524135258.GF6749@1wt.eu>
In-Reply-To: <20080524135258.GF6749@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Willy Tarreau <w@1wt.eu>
Cc: David Greaves <david@dgreaves.com>, Greg KH <greg@kroah.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, LinuxRaid <linux-raid@vger.kernel.org>, stable@kernel.org

Willy Tarreau wrote:

> It would have helped to CC stable (fixed) and to give the mainline commit
> ID since the stable branch only holds already merged patches. Greg, the
> commit is 6ab455ee...
> 
> Willy

Yup I'll agree that this should probably go to -stable unless hch or
dchinner disagree.

FWIW I've already put it in the Fedora kernels.

-Eric
