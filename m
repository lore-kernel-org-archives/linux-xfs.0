Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbdH2PMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 11:12:01 -0400
Date: Tue, 29 Aug 2017 08:11:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 00/12] xfs: more and better verifiers
Message-ID: <20170829151159.GA12841@infradead.org>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
 <20170818070516.GA15291@infradead.org>
 <20170818170607.GK4796@magnolia>
 <20170821081333.GB31761@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170821081333.GB31761@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, Aug 21, 2017 at 01:13:33AM -0700, Christoph Hellwig wrote:
> So what do you think of the version that adds real printks for
> each condition including more details like the one verifier I
> did below?  Probably needs some unlikely annotations, though.

Given that there was another resend of the series I'd be really
curious about the answer to this?
