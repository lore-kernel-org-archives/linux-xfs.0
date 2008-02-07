Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Feb 2008 00:36:38 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m178aXbg009026
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 00:36:34 -0800
Received: from pentafluge.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 591C95ACB8D
	for <xfs@oss.sgi.com>; Thu,  7 Feb 2008 00:36:47 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40]) by cuda.sgi.com with ESMTP id NS2zC7ahdC2YDfpr for <xfs@oss.sgi.com>; Thu, 07 Feb 2008 00:36:47 -0800 (PST)
Date: Thu, 7 Feb 2008 08:35:54 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [review] Remove the xfs refcache
Message-ID: <20080207083554.GA11119@infradead.org>
References: <4765EC66.5020202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4765EC66.5020202@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Dec 17, 2007 at 02:26:30PM +1100, Donald Douwsma wrote:
> Remove the xfs_refcache, it was only needed while we were still building for
> 2.4 kernels.

Given that we finally agreed that this form of refcache shouldn't come
back can you commit the patch?
