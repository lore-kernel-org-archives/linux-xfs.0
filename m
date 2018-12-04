Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39106 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbeLDFse (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Dec 2018 00:48:34 -0500
Date: Tue, 4 Dec 2018 00:48:32 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: hard fail dax mount on unsupported devices
Message-ID: <20181204054832.GH4981@thunk.org>
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
 <1539027169-23332-3-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539027169-23332-3-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Mon, Oct 08, 2018 at 02:32:48PM -0500, Eric Sandeen wrote:
> As dax inches closer to production use, an administrator should not
> be surprised by silently disabling the feature they asked for.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Thanks, applied.

					- Ted
