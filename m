Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38481 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727105AbfFRPCr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 11:02:47 -0400
Date: Tue, 18 Jun 2019 11:02:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Message-ID: <20190618150242.GA4576@mit.edu>
References: <20190611153916.13360-1-amir73il@gmail.com>
 <20190611153916.13360-2-amir73il@gmail.com>
 <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
 <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Murphy Zhou <jencce.kernel@gmail.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 18, 2019 at 12:16:45PM +0300, Amir Goldstein wrote:
> On Tue, Jun 18, 2019 at 12:02 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > Would you mind updating sha1 after it get merged to Linus tree?
> >
> > That would be helpful for people tracking this issue.
> >
> 
> This is the commit id in linux-next and expected to stay the same
> when the fix is merged to Linus tree for 5.3.

When I talked to Darrick last week, that was *not* the sense I got
from him.  It's not necessarily guaranteed to be stable just yet...

     	   	    			   - Ted
