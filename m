Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38359 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751973AbdFHH4A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2017 03:56:00 -0400
Date: Thu, 8 Jun 2017 00:55:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: remove bli from AIL before release on
 transaction abort
Message-ID: <20170608075549.GC24866@infradead.org>
References: <1496750930-53954-1-git-send-email-bfoster@redhat.com>
 <1496750930-53954-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496750930-53954-3-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
