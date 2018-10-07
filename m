Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:34654 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbeJGWAH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Oct 2018 18:00:07 -0400
Date: Sun, 7 Oct 2018 08:52:37 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] docs: improve readability for people with poorer
 eyesight
Message-ID: <20181007085237.6281983e@lwn.net>
In-Reply-To: <20181005010603.GA6702@magnolia>
References: <20181005010603.GA6702@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-doc@vger.kernel.org

On Thu, 4 Oct 2018 18:06:03 -0700
"Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> o my eyesight still hasn't fully recovered, so in the meantime it's
> been difficult to read the online documentation.  Here's some stylesheet
> overrides I've been using to make it easier for me to read them:
> https://djwong.org/docs/kdoc/index.html
> 
> ---
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> My eyesight is not in good shape, which means that I have difficulty
> reading the online Linux documentation.  Specifically, body text is
> oddly small compared to list items and the contrast of various text
> elements is too low for me to be able to see easily.
> 
> Therefore, alter the HTML theme overrides to make the text larger and
> increase the contrast for better visibility, and trust the typeface
> choices of the reader's browser.
> 
> For the PDF output, increase the text size, use a sans-serif typeface
> for sans-serif text, and use a serif typeface for "roman" serif text.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I've been wanting to find some time to work on our stylesheets for years;
what we have now is far from ideal (or attractive) IMO.  This is a good
step in the right direction - applied, thanks.

jon
