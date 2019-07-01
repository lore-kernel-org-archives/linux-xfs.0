Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59473 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfGAIZi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Jul 2019 04:25:38 -0400
Date: Mon, 1 Jul 2019 10:25:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V2] block: fix .bi_size overflow
Message-ID: <20190701082536.GA22539@lst.de>
References: <20190701071446.22028-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701071446.22028-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Liu Yiding <liuyd.fnst@cn.fujitsu.com>, kernel test robot <rong.a.chen@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
