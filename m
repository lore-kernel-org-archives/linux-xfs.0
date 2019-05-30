Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3GEf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 May 2019 02:04:35 -0400
Date: Wed, 29 May 2019 23:04:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to package e2scrub
Message-ID: <20190530060426.GA30438@infradead.org>
References: <20190529120603.xuet53xgs6ahfvpl@work>
 <20190529182111.GA5220@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529182111.GA5220@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, May 29, 2019 at 11:21:11AM -0700, Darrick J. Wong wrote:
> Indeed.  Eric picked "xfsprogs-xfs_scrub" for Rawhide, though I find
> that name to be very clunky and would have preferred "xfs_scrub".

Why not just xfs-scrub?
