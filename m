Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751912AbeEGOz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 10:55:28 -0400
Date: Mon, 7 May 2018 07:55:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/10] xfs: get rid of the log item descriptor
Message-ID: <20180507145527.GL7476@infradead.org>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502080157.11386-11-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Looks sensible.  Note that the LI_TRANS flag added earlier is now
redundant.
