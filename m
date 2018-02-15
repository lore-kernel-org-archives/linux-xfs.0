Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39026 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161667AbeBOVLX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Feb 2018 16:11:23 -0500
Subject: Re: [PATCH] debian: add build-depends on pkg-config
References: <20180215065134.GP5217@magnolia>
 <268bfeb5-f7bf-b2b2-74c3-2c6c74d8b427@sandeen.net>
 <CAFMei7PkvECcgsuj610O=PsrbqYD3mw0Wnc-Z71n5PZFtRkLYg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9462da94-5b2e-05f4-8715-67acb37df529@sandeen.net>
Date: Thu, 15 Feb 2018 15:11:21 -0600
MIME-Version: 1.0
In-Reply-To: <CAFMei7PkvECcgsuj610O=PsrbqYD3mw0Wnc-Z71n5PZFtRkLYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nathan Scott <nathans@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On 2/15/18 3:10 PM, Nathan Scott wrote:
> 
> 
> On Fri, Feb 16, 2018 at 4:02 AM, Eric Sandeen <sandeen@sandeen.net <mailto:sandeen@sandeen.net>> wrote:
> 
>     On 2/15/18 12:51 AM, Darrick J. Wong wrote:
>     > From: Darrick J. Wong <darrick.wong@oracle.com <mailto:darrick.wong@oracle.com>>
>     >
>     > Since the configure scripts now depend on pkg-config to autodetect where
>     > systemd service files go, we need to list pkg-config as a build
>     > dependency.
>     >
>     > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com <mailto:darrick.wong@oracle.com>>
> 
>     I'd love to have a Debian-savvy person look over these things.
> 
>     Nathan maybe? :)
> 
> 
> LGTM.  Feel free to add
> 
> Reviewed-by: Nathan Scott <nathans@debian.org <mailto:nathans@debian.org>>
> 
> I also have a couple of other debian packaging tweaks I'd like to make, but
> no time this week - is the release pending immediately or is there any time
> early next week Eric?  (else it can wait for next time of course)

Not immediately, if you'd like to fix some things next week I'll try to remember
to wait.  :)

Thanks,
-Eric
