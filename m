Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46851 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031333AbdAIPeT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Jan 2017 10:34:19 -0500
Date: Mon, 9 Jan 2017 16:34:15 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: minleft fixes V2
Message-ID: <20170109153415.GA27197@lst.de>
References: <1482436822-31546-1-git-send-email-hch@lst.de> <20170105012159.GS1859@eguan.usersys.redhat.com> <20170105020105.GC17846@birch.djwong.org> <20170108103647.GD26451@lst.de> <20170108160959.GD62847@bfoster.bfoster> <20170108181002.GA3732@birch.djwong.org> <20170109152205.GA22368@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170109152205.GA22368@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 09, 2017 at 10:22:06AM -0500, Brian Foster wrote:
> Hmm, is this something that can be enabled locally (e.g., on posts to
> the list) without having to merge stuff prematurely?

Any linux developer can add their repos to the kbuild bot.  I usually
push my non-trivial patchset to one of my repos covered by it before
sending them out.
