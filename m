Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47970 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751066AbeADIae (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 03:30:34 -0500
Date: Thu, 4 Jan 2018 09:30:33 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 16/18] wait_bit: introduce
        {wait_on,wake_up}_atomic_one
Message-ID: <20180104083033.GL2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com> <151407704609.38751.16443220639298609451.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407704609.38751.16443220639298609451.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, linux-xfs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
