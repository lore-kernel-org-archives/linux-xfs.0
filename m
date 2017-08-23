Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57822 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932396AbdHWSa6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 14:30:58 -0400
Date: Wed, 23 Aug 2017 11:30:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/13] dax: Create local variable for VMA in
 dax_iomap_pte_fault()
Message-ID: <20170823183058.GB13778@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-5-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-5-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
