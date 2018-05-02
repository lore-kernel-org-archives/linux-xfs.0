Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39958 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750936AbeEBQel (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 May 2018 12:34:41 -0400
Date: Wed, 2 May 2018 18:37:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/13] xfs: refactor dquot iteration
Message-ID: <20180502163716.GE27020@lst.de>
References: <152506698177.21553.13500862866416804148.stgit@magnolia> <152506707631.21553.6110605230681161129.stgit@magnolia> <20180501134522.GE4525@bfoster.bfoster> <20180501155338.GC4127@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180501155338.GC4127@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, hch@lst.de

On Tue, May 01, 2018 at 08:53:38AM -0700, Darrick J. Wong wrote:
> > With that fixed:
> 
> Fixed by moving the offset assignment up a few lines.

Can you resend the fixed patch?
