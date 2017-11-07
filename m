Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:46314 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932982AbdKGSrb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Nov 2017 13:47:31 -0500
Date: Tue, 7 Nov 2017 18:46:58 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171107184658.56b87d41@alans-desktop>
In-Reply-To: <20171107182903.GA4588@kroah.com>
References: <20171107020607.GA26910@magnolia>
        <20171107072040.GB4586@infradead.org>
        <20171107073940.GB4654@kroah.com>
        <20171107172042.GB26910@magnolia>
        <20171107182903.GA4588@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org

> Given that it had no license text on it at all, it "defaults" to GPLv2,
> so the GPLv2 SPDX identifier was added to it.
> 
> No copyright was changed, nothing at all happened except we explicitly
> list the license of the file, instead of it being "implicit" before.

Well if Christoph owns the copyright (if there is one) and he has stated
he believes it is too trivial to copyright then it needs an SPDX tag that
indicates the rightsholder has stated it's too trivial to copyright and
(by estoppel) revoked any right they might have to pursue a claim.

I'm sure there's a correct SPDX tag for that ;-)

Alan
