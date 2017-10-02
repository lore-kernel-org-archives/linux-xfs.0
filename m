Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:55488 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdJBOLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Oct 2017 10:11:00 -0400
Received: by mail-it0-f50.google.com with SMTP id 4so7449048itv.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 Oct 2017 07:11:00 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Suggested XFS setup/options for 10TB file system w/ 18-20M files.
From: "R. Jason Adams" <rjasonadams@gmail.com>
In-Reply-To: <8066DE0B-5CC2-4B64-ACC1-4EA1462B450A@gmail.com>
Date: Mon, 2 Oct 2017 10:10:58 -0400
Content-Transfer-Encoding: quoted-printable
Message-Id: <97EA81E1-3908-4C8F-9F1F-B4AAAD47A416@gmail.com>
References: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
 <fb88053a-873d-92f9-198d-ee8d4f841658@sandeen.net>
 <8066DE0B-5CC2-4B64-ACC1-4EA1462B450A@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org


> On Oct 2, 2017, at 9:49 AM, R. Jason Adams <rjasonadams@gmail.com> =
wrote:
>=20
>> Why 1k inodes?
>=20
> Our extended attributes average ~200B .. figured a little extra room =
wouldn=E2=80=99t hurt?


Hrm.. this has me wondering.. is a downside of the larger inode that =
less of them can be cached in memory?

Thanks,
R. Jason Adams

