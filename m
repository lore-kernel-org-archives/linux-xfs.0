Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44943 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdH1Jol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 05:44:41 -0400
Date: Mon, 28 Aug 2017 02:44:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] xfs: skip bmbt block ino validation during owner
 change
Message-ID: <20170828094441.GA14155@infradead.org>
References: <20170825150557.43010-1-bfoster@redhat.com>
 <20170825150557.43010-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825150557.43010-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Looks fine with this or another name for the flag:

Reviewed-by: Christoph Hellwig <hch@lst.de>
