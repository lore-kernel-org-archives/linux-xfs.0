Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38561 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdICHZP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 3 Sep 2017 03:25:15 -0400
Date: Sun, 3 Sep 2017 09:25:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: remove "no-allocation" reservations for file
        creations
Message-ID: <20170903072513.GA14807@lst.de>
References: <20170821082404.3387-1-hch@lst.de> <20170823202213.GA4796@magnolia> <20170824004755.GC21024@dastard> <20170829180445.GU4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829180445.GU4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

Looks like this didn't make the 4.14 for-next branch either.  I guess
we'll just consider it for the next round?
