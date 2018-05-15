Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43866 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752149AbeEONI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 09:08:29 -0400
Date: Tue, 15 May 2018 06:08:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
Message-ID: <20180515130802.GB11514@magnolia>
References: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
 <20180514173610.GC4933@magnolia>
 <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
 <d6405778-f3cb-57c8-33d6-6ea66fe06b44@sandeen.net>
 <CAJCQCtSSEmwAzED6uzkevV_o4cxwhcZ9sf398wG-7HNCg3dOsA@mail.gmail.com>
 <20180514191114.GB4937@magnolia>
 <20180515122015.GA2213@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180515122015.GA2213@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Murphy <lists@colorremedies.com>, Eric Sandeen <sandeen@sandeen.net>, xfs list <linux-xfs@vger.kernel.org>

On Tue, May 15, 2018 at 05:20:15AM -0700, Christoph Hellwig wrote:
> On Mon, May 14, 2018 at 12:11:14PM -0700, Darrick J. Wong wrote:
> > We're working on moving all that to Documentation/, time permitting.
> 
> Of the kernel tree?  Of xfsprogs?  Why?

The kernel Documentation/ directory.  It's fewer trees for us/me to
maintain, and we can take advantage of the kernel's builtin
html/pdf/epub generator.  That said, the whole thing could get bogged
down in conversion hell, but for now I'm starting by incorporating
algorithms into the existing book and fixing the errors & other
weirdness in the existing text.

--D
