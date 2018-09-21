Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44909 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391279AbeIVBYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Sep 2018 21:24:36 -0400
Received: by mail-pl1-f196.google.com with SMTP id ba4-v6so6375494plb.11
        for <linux-xfs@vger.kernel.org>; Fri, 21 Sep 2018 12:34:17 -0700 (PDT)
Date: Fri, 21 Sep 2018 12:34:14 -0700
From: Brian Norris <briannorris@chromium.org>
Subject: Re: [PATCH xfsprogs] build: don't assume $BUILD_CC has fsmap.h just
 because $CC does
Message-ID: <20180921193412.GA224566@ban.mtv.corp.google.com>
References: <20180906183529.117251-1-briannorris@chromium.org>
 <30774ff1-57c1-c9f4-4ec3-31c177b11489@sandeen.net>
 <20180906225534.GA114388@ban.mtv.corp.google.com>
 <20180921183700.GA203751@ban.mtv.corp.google.com>
 <1daeaef0-af23-0d2d-cc30-e6f3ef12205c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1daeaef0-af23-0d2d-cc30-e6f3ef12205c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 21, 2018 at 02:12:31PM -0500, Eric Sandeen wrote:
> On 9/21/18 1:37 PM, Brian Norris wrote:
> > Ping? Should I send a new version that combines our patches?
> 
> Hi Brian - I'm not ignoring your patch, I've just been working on getting
> libxfs synced for 4.19 before merging anything else - this is usually how
> I work when patches come in near the beginning of a release cycle.
> I'll revisit your patch & reach out to you if I have other questions or
> suggestions when I get there, ok?  Sorry for the delay.

No problem at all. I don't think I understood the development patterns
here anyway. It just wasn't clear if there was a next action for me.
This makes it clear.

Thanks!

Brian
