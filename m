Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40635 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389908AbfA1Q2C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jan 2019 11:28:02 -0500
Date: Mon, 28 Jan 2019 17:28:01 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: fix a use after free in iomap_dio_rw
Message-ID: <20190128162801.GA12264@lst.de>
References: <20190117075707.8640-1-hch@lst.de> <20190117212658.GD6173@dastard> <20190128162233.GF4368@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128162233.GF4368@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chandan Rajendra <chandan@linux.ibm.com>

On Mon, Jan 28, 2019 at 08:22:33AM -0800, Darrick J. Wong wrote:
> Fixed.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Are you going to pick this one (and the migrate page fix) up for
5.0-rc?
