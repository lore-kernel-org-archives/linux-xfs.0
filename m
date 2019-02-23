Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:50770 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfBWLBw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Feb 2019 06:01:52 -0500
Message-ID: <5C71281A.9020700@tlinx.org>
Date: Sat, 23 Feb 2019 03:01:46 -0800
From: L A Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] xfsprogs v4.20.0 released
References: <59a16d27-0370-12c3-4590-071f88a9d3fb@sandeen.net> <5C70AC01.3060306@tlinx.org> <20190223024936.GV6503@magnolia>
In-Reply-To: <20190223024936.GV6503@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>



On 2/22/2019 6:49 PM, Darrick J. Wong wrote:

> If /usr is broken and won't mount, use xfs_repair to make it mountable,
> just like we have always done.
> 
> xfs_scrub is only meant to be used as a background process on a system
> once it has come completely up.  xfs_repair's role has not changed -- it
> is still the intended tool to fix filesystems that will not mount or
> that cannot be fixed while online.
---
	That people/projects have moved utils or the libs needed
to mount, repair or restore, a /usr partition has been one of
my ongoing concerns. 

Thanks for clarifying & cheers!
