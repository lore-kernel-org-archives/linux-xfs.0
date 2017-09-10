Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43594 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750788AbdIJCXX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 Sep 2017 22:23:23 -0400
Subject: Re: [PATCH] xfsdump: Use c99 defined int64_t instead of __int64_t
References: <20170909150230.44139-1-raj.khem@gmail.com>
 <9ba360ec-ef78-ad8d-c83e-9b95f7d60e60@sandeen.net>
 <CAMKF1soFadOi=4EEAZgV4ufmPeFqKRbfMJmUr0W9hCjqPq1YZQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e94b6554-10e3-6212-27cb-a94a82df0cc0@sandeen.net>
Date: Sat, 9 Sep 2017 21:23:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAMKF1soFadOi=4EEAZgV4ufmPeFqKRbfMJmUr0W9hCjqPq1YZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-xfs@vger.kernel.org

On 9/9/17 7:18 PM, Khem Raj wrote:
> On Sat, Sep 9, 2017 at 12:09 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> Seems fine, but are the __uint32_t instances in the code not a problem?
>>
> 
> yes they are and I had a seprate patch for them, which I will send
> once  I have fixed the tab formatting issues with it. May be I should squash
> then into one

yes please.

thanks,
-Eric
