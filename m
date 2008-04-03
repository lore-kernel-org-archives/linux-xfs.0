Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:31:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33NVhaX022695
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:31:45 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8427B91214C
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 16:32:20 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id ldDT0p9JiG8ZXFjT for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 16:32:20 -0700 (PDT)
Subject: Re: [PATCH 2/7] XFS: ASCII case-insensitive support
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20080403225556.GB448@infradead.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
	 <20080402062708.071715758@chook.melbourne.sgi.com>
	 <20080403225556.GB448@infradead.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 10:01:08 +1100
Message-Id: <1207263668.21048.147.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com


On Thu, 2008-04-03 at 18:55 -0400, Christoph Hellwig wrote:
> 
> is the use of STATIC now officially phased out for XFS?

userspace requires it for a bunch of stuff (via libxfs).

cheers.

-- 
Nathan
