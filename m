Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from forward3h.cmail.yandex.net ([87.250.230.18]:37686 "EHLO
        forward3h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932187AbcLLUtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 15:49:43 -0500
From: Ozgur Karatas <okaratas@member.fsf.org>
In-Reply-To: <cbf01379-fbcb-b42e-abc1-1b368b9d6633@sandeen.net>
References: <987271481540010@web27o.yandex.ru>
         <66c68b88-e338-1d9a-b9dd-b8d858ebf349@sandeen.net>
         <1481566450.1764.23.camel@perches.com>
         <50420874-ffde-283f-f2e7-cb2ebbec1b84@sandeen.net>
         <737751481574841@web26j.yandex.ru> <cbf01379-fbcb-b42e-abc1-1b368b9d6633@sandeen.net>
Subject: Re: [PATCH 1/1] Fixed to codestyle
MIME-Version: 1.0
Message-Id: <1093131481575777@web26g.yandex.ru>
Date: Mon, 12 Dec 2016 22:49:37 +0200
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Joe Perches <joe@perches.com>, "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

12.12.2016, 22:41, "Eric Sandeen" <sandeen@sandeen.net>:
> Well, rule #1 for newbies is "code style patches aren't
> very useful, and usually are not welcomed by the project."
>
> Making style changes just because checkpatch told you to is
> not particularly helpful. If it were important, it would have
> been done by now. If it hasn't been done by now, odds are
> it's not important. :)
>
> If you are writing /new/ code, then sure, conform to the kernel
> style, /aided/ by checkpatch.pl, and using your discretion as
> well.
>
> If you are just now looking at xfs/* code, best not to start
> with "style" cleanups. You'll find this to be true in general
> across the kernel, maintainers are usually not thrilled to have
> this kind of patch.

Dear Eric;
this information was very good and thank you, I will try for the better :)

> If you want to start with a new project, learn about the code,
> learn what it /does/, learn how to use it. use it. Find things
> that don't work as expected, or could work better. Look into
> bug reports and if you understand them, and the code involved,
> try to write and test a fix. But don't go looking for whitespace
> nitpicks.

I get it now, I understand but I think the error was only uuid functions.
Now, me more careful.

>>  Sorry,

>
> No need to be sorry, this is how we learn. ;) But really, making
> purely cosmetic changes for their own sake is not helpful in
> general.
>
> -Eric

I have mentioned above, thank you for all the information. 
You are helping me and  your mentoring in some way.

Regards

Ozgur Karatas
