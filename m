Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36893 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdHEN4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Aug 2017 09:56:40 -0400
Date: Sat, 5 Aug 2017 06:56:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Fix leak of discard bio
Message-ID: <20170805135639.GA16938@infradead.org>
References: <20170802083741.4600-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170802083741.4600-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, stable@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
