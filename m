Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:49606 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752487AbdKHRUb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Nov 2017 12:20:31 -0500
Date: Wed, 8 Nov 2017 17:19:38 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171108171938.7df66c65@alans-desktop>
In-Reply-To: <20171107214259.GC16026@wotan.suse.de>
References: <20171107020607.GA26910@magnolia>
        <20171107072040.GB4586@infradead.org>
        <20171107073940.GB4654@kroah.com>
        <20171107172042.GB26910@magnolia>
        <20171107182903.GA4588@kroah.com>
        <20171107184658.56b87d41@alans-desktop>
        <20171107191526.x3rzfcnnlmaz264d@thunk.org>
        <20171107192846.GA24617@infradead.org>
        <20171107202648.GB10679@kroah.com>
        <20171107214259.GC16026@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Richard Fontana <fontana@sharpeleven.org>, linux-kernel@vger.kernel.org

>     By default all files without license information are under the default
>     license of the kernel, which is GPL version 2.

Which is factually incorrect.

They are under a licence that is at least as permissive as GPL v2.
However they may be under a more permissive licence and as you are not
the rightsholder you don't have the right to relicence them mroe
restrictvely.

For example

I find a reference piece of code whose author says it is 'too trivial to
copyright'. I (not the author0 place that code in the kernel. The licence
on that code is still 'too trivial to copyright' (by estoppel). That's
GPL 2 compliant but it is *NOT* GPL.

As anyone can contribute third party code that is GPL compliant
legitimately you can't assume any unmarked code is GPL, merely 'at least
GPL'.

Alan
