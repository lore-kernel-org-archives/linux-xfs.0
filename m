Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42475 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751535AbdARIt0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Jan 2017 03:49:26 -0500
Date: Wed, 18 Jan 2017 09:49:25 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: fix COW writeback race
Message-ID: <20170118084925.GA23790@lst.de>
References: <1484639331-2137-1-git-send-email-hch@lst.de> <20170117134421.GB12426@bfoster.bfoster> <20170117143721.GA32641@lst.de> <20170117171449.GC12426@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170117171449.GC12426@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

It seems like this relative diff is all that's needed.  I'll run it
through the reproducer and will resend later.

