Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33337 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752142AbdCaGwA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 02:52:00 -0400
Date: Fri, 31 Mar 2017 08:51:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends
        of files
Message-ID: <20170331065157.GA2922@lst.de>
References: <22a11e65fd5037498a78de61f3ed4dae466ad854.1489791330.git.calvinowens@fb.com> <19504ff40a16efff2e51d85388fce5be578edbc3.1489985397.git.calvinowens@fb.com> <20170321113932.GA58653@bfoster.bfoster> <ab15bba5-601a-3297-959c-ddb04b42d082@fb.com> <20170331041800.ugi4wgmbqx44mbwa@Haydn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170331041800.ugi4wgmbqx44mbwa@Haydn>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Calvin Owens <calvinowens@fb.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, kernel-team@fb.com, stable@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
