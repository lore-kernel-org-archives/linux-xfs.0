Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34284 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfBAH51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 02:57:27 -0500
Date: Thu, 31 Jan 2019 23:57:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8] xfs: incore unlinked list
Message-ID: <20190201075727.GA22295@infradead.org>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897667054.26065.13164381203002725289.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 03:17:50PM -0800, Darrick J. Wong wrote:
> If you're going to start using this mess, you probably ought to just
> pull from my git trees: kernel[1], xfsprogs[2], and xfstests[3].

Why would we need updated xfsprogs for this?
