Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:41786 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933175AbeFLSxi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 14:53:38 -0400
Received: by mail-lf0-f49.google.com with SMTP id d24-v6so3643lfa.8
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jun 2018 11:53:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a2dbfee3-f5dc-b4c3-24c9-153fe3304d10@sandeen.net>
References: <e462d333d2089a7c3c59e7584fa83f720365fa46.camel@quantentunnel.de>
 <0ae6d0d5984dcd9c703720bdf41b6da1333267b0.camel@quantentunnel.de>
 <20180605082917.azuql22j5wnb7wof@odin.usersys.redhat.com> <CAAxjCEwS5mcEMPCqJmUiUParsaG7Fxzf0c0GxkJURv85fYuJyw@mail.gmail.com>
 <a2dbfee3-f5dc-b4c3-24c9-153fe3304d10@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Tue, 12 Jun 2018 20:53:36 +0200
Message-ID: <CAAxjCExfy6ysDCOPX7G9HNJvqojbgQHu54QwMrcGROhu1JnMLg@mail.gmail.com>
Subject: Re: Strange XFS problem
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 5, 2018 at 4:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> In all seriousness, if you would like to update the translations that wou=
ld
> be great.  The Polish translation is the only one that receives regular
> updates today.

I've looked into it, but this seems to me like a gargantuan task
because there is so much internal inconsistency that I wouldn't even
know where to start. "Extent" for example: sometimes this is
translated as "Erweiterung" (nonsense, that's extension). Sometimes
it's left verbatim. This is what I'd be leaning towards as well. Other
times, it got translated as "Ausma=C3=9F", which in another context is in
fact a translation for "extent" (as in: the extent of a catastrophy),
but makes no sense here. Also "Bereich" and "Umfang" are used
sometimes, of which only the former makes a slight bit of sense. That
in addition to my general under-appreciation of low-level technical
translation. They are usually much less comprehensible and the
gibberish needs to be translated back anyway in order to any sense of,
apart from the fact that the original text is searchable, in stark
contrast to the translation.
