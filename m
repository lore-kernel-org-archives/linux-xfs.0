Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38005 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753433AbdBJVHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Feb 2017 16:07:07 -0500
Date: Fri, 10 Feb 2017 22:06:38 +0100
From: Greg KH <greg@kroah.com>
Subject: Re: Inclusion of a3916e528b917851a4 ("xfs: fix broken multi-fsb
 buffer logging") in 4.4-stable
Message-ID: <20170210210638.GB26049@kroah.com>
References: <24b4d9c7-6fd3-3e90-a614-92f79ecc3b81@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24b4d9c7-6fd3-3e90-a614-92f79ecc3b81@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, stable@vger.kernel.org, sandeen@redhat.com, bfoster@redhat.com

On Thu, Feb 09, 2017 at 02:22:05PM +0200, Nikolay Borisov wrote:
> Hello,
> 
> 
> I'd like to ask for a3916e528b917851a4 ("xfs: fix broken multi-fsb
> buffer logging") to be included into at least the stable 4.4 branch.
> I've confirmed that it causes a kernel crash on xfs/306 test. It applies
> cleanly to 4.4.47, it's likely that it needs to be backported to older
> releases as well but I'd defer this call to Eric or Brian as they know
> the code more intimately.

Any reason you didn't include the XFS maintainer and mailing list in
this request?

Now cc:ed...

greg k-h
