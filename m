Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20075 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdH2AZY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 20:25:24 -0400
Date: Mon, 28 Aug 2017 17:25:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: My thesis about mkfs
Message-ID: <20170829002520.GK4757@magnolia>
References: <CACj3i71iYMn8+nwUmXUHfR-c2c8XdqfdTsgx5Ohkb2k1FXUd0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i71iYMn8+nwUmXUHfR-c2c8XdqfdTsgx5Ohkb2k1FXUd0w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Aug 28, 2017 at 04:39:48PM +0200, Jan Tulak wrote:
> Hi guys
> 
> This email is about my thesis I did and which I'm sending you in case
> you are interested: Refactoring and Verification of the Code of
> mkfs.xfs
> 
> The refactoring part (intro and summary of chapter 3) can be somehow
> interesting if you want to get a small overview of how it feels to
> just jump into a project like this without any experience in regular
> development of bigger open source projects (bigger than 1-2 man
> shows). Other than that, you won't find there much.
> 
> The testing part (chapters 5 and 6) shows how CppCheck, Coverity, and
> GCC and Clang compares to each other, in various levels of
> aggressiveness. Spoiler: Coverity is pretty good and we are doing well
> that we use it. :-)
> 
> I'm sorry I didn't publish it right after the defence; I wanted to go
> through it and make some minor edits, but in the weeks since the
> defence, I forgot what they told me, so I decided I will just send it
> as it is, with no other delays. :-)
> 
> The thesis was defended and I got a master degree, but I still
> appreciate any comments. :-)
> 
> 
> Download here:
> https://github.com/jtulak/thesis-mmm/releases

Congratulations!  I'll look it over soon.

--D

> 
> 
> 
> Cheers,
> Jan
> 
> PS: Eric, I hope I didn't overlook anything you pointed out in the
> proofreading. Thank you once more for that. :-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
