Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 00:46:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K7kgTg006710
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:46:44 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C62E12569E6
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:47:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id kOOLt2ulbulDM3yF for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:47:15 -0700 (PDT)
Date: Thu, 20 Mar 2008 03:46:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Factor repeated code in xfs_ialloc_ag_alloc
Message-ID: <20080320074644.GF19969@infradead.org>
References: <20080320052000.GZ95344431@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320052000.GZ95344431@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 20, 2008 at 04:20:00PM +1100, David Chinner wrote:
> Factor repeated code that determines the cluster alignment of
> an inode extent.

Nice one, looks good.
