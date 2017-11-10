Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:57294 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754021AbdKJVLF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Nov 2017 16:11:05 -0500
Date: Fri, 10 Nov 2017 21:10:28 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171110211028.33055ba2@alans-desktop>
In-Reply-To: <20171109081659.GB27461@kroah.com>
References: <20171107020607.GA26910@magnolia>
        <20171107072040.GB4586@infradead.org>
        <20171107073940.GB4654@kroah.com>
        <20171107172042.GB26910@magnolia>
        <20171107182903.GA4588@kroah.com>
        <20171108234704.GH4094@dastard>
        <20171109081659.GB27461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org

> When a file does not have a license, again, all lawyers I have worked
> with said it is implicitly GPLv2

I am surprised that they did not immediately see the fact that since the
code contributor was not neccessarily the rights holder you could make no
assumption as to the actual licencing beyond it being GPL compatible (or
having a right to sue whoever put it there).

Did you explain the contribution process sufficiently clearly ?

> Again, no, the copyright was not changed.  Whom ever held the original
> copyright still holds it today.

On the contrary if it was implicitly LGPL you've just exercised the right
to make it GPL and messed it up for others. In the other cases your error
is probably legally actionable in certain jurisdictions if someone was so
unpleasantly minded.

Alan
