Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbeC1MCO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Mar 2018 08:02:14 -0400
Date: Wed, 28 Mar 2018 05:02:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: FreeBSD and xfsprogs ?
Message-ID: <20180328120212.GA1838@infradead.org>
References: <cem@freebsd.org>
 <CAG6CVpU3qe10UUY6B-N4fs9WTwwUerVcJh0CrP22D8hvB4Z14Q@mail.gmail.com>
 <201803261953.w2QJrYQm028227@slippy.cwsent.com>
 <CAG6CVpXi3rb-NfLUXQqzStipmwRviKJPMpgKeQA9DfBmOWJ5oQ@mail.gmail.com>
 <20180327160714.GB4818@magnolia>
 <8396fd92-3a64-a84f-b110-7edc6f0844b0@redhat.com>
 <20180327223201.GR18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327223201.GR18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, Conrad Meyer <cem@freebsd.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "freebsd-arch@freebsd.org" <freebsd-arch@freebsd.org>

On Wed, Mar 28, 2018 at 09:32:01AM +1100, Dave Chinner wrote:
> We don't support fuse-lkl XFS filesystems on Linux, so I'm not sure
> that using it on some other platform compels us to maintain a
> current userspace tool port to those platforms...

IFF we have someone signing up to maintain the FreeBSD port it seems
like a whortwhile exercise.  But that is a big IFF.

For now I'd say give it a grace period of another release or two to
see if someone is going to maintain it properly and if not drop it.
