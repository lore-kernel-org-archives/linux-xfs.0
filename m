Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54944 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932076AbeDWRcc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:32:32 -0400
Date: Mon, 23 Apr 2018 19:33:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/13] xfs: report failing address when dquot verifier
        fails
Message-ID: <20180423173354.GK834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440963171.29601.16982578523210467285.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440963171.29601.16982578523210467285.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

On Sun, Apr 22, 2018 at 08:07:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Pass the failing address through to the corruption report when dquot
> verifiers fail.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
